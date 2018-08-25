/**
 * Copyright 2017 University of Victoria
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to
 * deal in the Software without restriction, including without limitation the
 * rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
 * sell copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
 * IN THE SOFTWARE.
 */
package com.rigiresearch.examgen.templates

import com.rigiresearch.examgen.model.ClosedEnded
import com.rigiresearch.examgen.model.CompoundQuestion
import com.rigiresearch.examgen.model.CompoundText
import com.rigiresearch.examgen.model.Examination
import com.rigiresearch.examgen.model.OpenEnded
import com.rigiresearch.examgen.model.Question
import com.rigiresearch.examgen.model.Section
import com.rigiresearch.examgen.model.TextSegment

import static com.rigiresearch.examgen.model.Examination.Parameter.COURSE
import static com.rigiresearch.examgen.model.Examination.Parameter.COURSE_REFERENCE_NUMBER
import static com.rigiresearch.examgen.model.Examination.Parameter.SECTIONS
import static com.rigiresearch.examgen.model.Examination.Parameter.TERM
import static com.rigiresearch.examgen.model.Examination.Parameter.TIME_LIMIT
import static com.rigiresearch.examgen.model.Examination.Parameter.TITLE
import com.rigiresearch.examgen.model.TrueFalse

/**
 * A Moodle XML Quiz template implementation.
 * @author Prashanti Angara (pangara@uvic.ca)
 * @date 2018-08-21
 * @version $Id$
 * @since 0.0.1
 */
class MoodleXMLQuiz implements Template {

    override render(Examination e, boolean printSolutions) '''
        «val section = e.parameters.get(SECTIONS) as Section»
        <?xml version="1.0" encoding="UTF-8"?>
        <quiz>
        <question type="category">
          <category>
            <text>$course$/«e.parameters.get(TITLE)»/«section»</text>       
          </category>
        </question>
        «FOR q : e.questions SEPARATOR "\n"»
          «q.render(false)»
        «ENDFOR»
        </quiz>
        
    '''

    override render(Question question, boolean printSolutions) {
        switch (question) {
            OpenEnded: question.render(false, false)
            ClosedEnded: question.render(false, false)
            TrueFalse: question.render(false, false)
            CompoundQuestion: question.render(false)
        }
    }

    override render(TextSegment segment) {
        switch (segment) {
            TextSegment.Simple: segment.styled
            CompoundText: segment.segments.map[it.styled].join
        }
    }

    /**
     * Applies styles to a rendered text segment.
     */
    def styled(TextSegment segment) {
        var CharSequence result = segment.text
        for (style : segment.styles) {
            result = result.styled(style)
        }
        return if (segment.styles.contains(TextSegment.Style.NEW_LINE))
            "<br/>" + result
        else
            result
    }

    /**
     * Applies the given style to a rendered text.
     */
    def styled(CharSequence text, TextSegment.Style style) {
        switch (style) {
            case BOLD: '''<strong>«text.escaped»</strong>'''
            case CODE: '''
            <code>
            «text.escaped»
            </code>
            '''
            case INLINE_CODE: '''<code>«text.escaped»</code>'''
            case ITALIC: '''<i>«text.escaped»</i>'''
            case CUSTOM: text
            case INHERIT: text.escaped
            case NEW_LINE: '''<br/>«text.escaped»'''
        }
    }

    /**
     * Escapes special Latex characters
     */
    def escaped(CharSequence text) {
        text.toString
            .replace("\'", "&apos;")
            .replace("&", "&amp;")
            .replace (">", "&gt;")
            .replace("<","&lt;")
    }

    /**
     * Renders an open-ended question.
     */
    def render(OpenEnded question, boolean child, boolean printSolutions) '''
		<question type="shortanswer">
		<name>
		  <text>shortanswer</text>
		</name>
		<questiontext format="html">
		<text><![CDATA[<p><pre>«question.statement.render»</pre><br></p>]]></text>
		</questiontext>
		«feedback»
		<defaultgrade>«question.points»</defaultgrade>
		<answer fraction="100" format="html">
		  <text><![CDATA[<p><pre>«question.answer.render»</pre><br></p>]]></text>
		</answer>
		</question>
    '''

     
    def isMultiChoice(ClosedEnded question) {
    	var multichoice = 0
    	for (option : question.options){
    		if (option.answer){
    			multichoice+=1;
    		}
    		if (multichoice > 1){
    			return true
    		}
    	}
    	return false
    }
    	
    /**
     * Renders a closed-ended question.
     */

    def render(ClosedEnded question, boolean child, boolean printSolutions) '''
			<question type="multichoice">
			<name>
			<text>closed-ended</text>
			</name>
			<questiontext format="html">
			<text><![CDATA[<p><pre>«question.statement.render»</pre><br></p>]]></text>
			</questiontext>
			«feedback»
			<defaultgrade>«question.points»</defaultgrade>
			<answernumbering>abc</answernumbering>
			<single>«IF question.isMultiChoice»false«ELSE»true«ENDIF»</single>
			«FOR option : question.options»
			<answer fraction=«IF option.answer»"100"«ELSE»"0"«ENDIF» format="html">
			  <text><![CDATA[<p><pre>«option.statement.render»</pre><br></p>]]></text>
			  <feedback format="html">
			    <text><![CDATA[<p><pre><br></pre><br></p>]]></text>
			  </feedback>
			</answer>
			«ENDFOR»
			</question>
    '''

    /**
     * Renders a True-False question.
     */
    def render(TrueFalse question, boolean child, boolean printSolutions) '''
        «IF !child»\question[«question.points»]«ENDIF»
        \TFQuestion{«IF question.answer»T«ELSE»F«ENDIF»}{«question.statement.render»}
    '''
    
    /**
     * Renders a compound question.
     */
    def render(CompoundQuestion question, boolean printSolutions) '''
        \question[«question.points»]
        «question.statement.render»
        \noaddpoints % to omit double points count
        \pointsinmargin\pointformat{} % deactivate points for children
        \begin{parts}
            «FOR child : question.children SEPARATOR "\n"»
                \part[«child.points»]{}
                «
                    switch (child) {
                        OpenEnded: child.render(true, printSolutions)
                        ClosedEnded: child.render(true, printSolutions)
                        TrueFalse: child.render(true, printSolutions)
                    }
                »
            «ENDFOR»
        \end{parts}
        \nopointsinmargin\pointformat{[\thepoints]} % activate points again
        \addpoints
    '''

	/**
	 * Default feedback for a question.
	 */
	def feedback() '''
	<correctfeedback format="html">
	  <text>Your answer is correct.</text>
	</correctfeedback>
	<partiallycorrectfeedback format="html">
	  <text>Your answer is partially correct.</text>
	</partiallycorrectfeedback>
	<incorrectfeedback format="html">
	  <text>Your answer is incorrect.</text>
	</incorrectfeedback>
	'''
}