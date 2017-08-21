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
import com.rigiresearch.examgen.model.ClosedEnded;
import com.rigiresearch.examgen.model.CompoundQuestion;
import com.rigiresearch.examgen.model.Examination;
import com.rigiresearch.examgen.model.OpenEnded;
import com.rigiresearch.examgen.model.TextSegment;
import java.text.SimpleDateFormat;
import java.util.Arrays;
import java.util.Date;
import java.util.HashMap;

/**
 * Main program.
 * @author Miguel Jimenez (miguel@uvic.ca)
 * @date 2017-08-12
 * @version $Id$
 * @since 0.0.1
 */
public final class Application {

    @SuppressWarnings("serial")
    public static void main(final String[] args) {
        final long seed = 1234;
        final String today = new SimpleDateFormat("yyyy-MM-dd")
            .format(new Date());
        final Examination exam01 = new Examination(
            new HashMap<Examination.Parameter, String>(){{
                put(Examination.Parameter.COURSE, "CSC 111");
                put(Examination.Parameter.COURSE_REFERENCE_NUMBER, "10691");
                put(Examination.Parameter.DATE, today);
                put(Examination.Parameter.SECTIONS, "B01");
                put(Examination.Parameter.TERM, "Fall 2017");
                put(Examination.Parameter.TIME_LIMIT, "20 min");
                put(Examination.Parameter.TITLE, "Quiz 1");
            }},
            new HashMap<Examination.Field, String>(){{
                put(Examination.Field.STUDENT_NAME, "");
                put(Examination.Field.STUDENT_ID, "");
                put(Examination.Field.GRADE, "");
            }},
            Arrays.asList(
                new CompoundQuestion(
                    new TextSegment.Simple("This is a group of questions"),
                    Arrays.asList(
                        new ClosedEnded(
                            new TextSegment.Simple("This is a question with options"),
                            50,
                            Arrays.asList(
                                new ClosedEnded.Option(
                                    true,
                                    new TextSegment.Simple("This is an option")
                                ),
                                new ClosedEnded.Option(
                                    false,
                                    new TextSegment.Simple("This is another option")
                                )
                            )
                        ),
                        new OpenEnded(
                            new TextSegment.Simple("Is this an open question?"),
                            50
                        )
                    )
                )
            )
        );
        final Examination exam02 = exam01.scrambled(seed);
        final Examination exam03 = exam02.scrambled(seed);
    }

}
