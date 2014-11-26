package enumerator;

import org.jruby.Ruby;
import org.jruby.runtime.load.BasicLibraryService;
import stream.RubyLazyEnumerator;

import java.io.IOException;

/**
 * Created by isaiah on 26/11/14.
 */
public class RubyLazyEnumeratorService implements BasicLibraryService {
        public boolean basicLoad(final Ruby runtime) throws IOException {
            RubyLazyEnumerator.createLazy(runtime);
            return true;
        }
}
