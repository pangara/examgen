import com.rigiresearch.quizgen.CloseEnded;
import com.rigiresearch.quizgen.CompoundQuestion;
import com.rigiresearch.quizgen.OpenEnded;
import com.rigiresearch.quizgen.TextSegment;
import java.util.Arrays;

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

/**
 * Main program.
 * @author Miguel Jimenez (miguel@uvic.ca)
 * @date 2017-08-12
 * @version $Id$
 * @since 0.0.1
 */
public final class Application {

    public static void main(final String[] args) {
        new CompoundQuestion(
            new TextSegment.Simple("This is a group of questions"),
            Arrays.asList(
                new CloseEnded(
                    new TextSegment.Simple("This is a question with options"),
                    Arrays.asList(
                        new CloseEnded.Option(
                            true,
                            new TextSegment.Simple("This is an option")
                        ),
                        new CloseEnded.Option(
                            false,
                            new TextSegment.Simple("This is another option")
                        )
                    )
                ),
                new OpenEnded(
                    new TextSegment.Simple("Is this an open question?")
                )
            )
        );
    }

}
