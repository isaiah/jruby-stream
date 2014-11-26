package stream;

import org.jruby.*;
import org.jruby.anno.JRubyMethod;
import org.jruby.runtime.Arity;
import org.jruby.runtime.Block;
import org.jruby.runtime.ThreadContext;
import org.jruby.runtime.builtin.IRubyObject;

import java.util.stream.Collectors;
import java.util.stream.Stream;

/**
 * Created by isaiah on 26/11/14.
 */
public class RubyLazyEnumerator extends RubyObject {
    private IRubyObject object;
    private IRubyObject size;
    private Stream<IRubyObject> stream;

    public RubyLazyEnumerator(Ruby runtime, RubyClass metaClass) {
        super(runtime, metaClass);
    }

    public RubyLazyEnumerator(ThreadContext context, RubyClass metaClass, Stream<IRubyObject> stream) {
        super(context.getRuntime(), metaClass);
        this.stream = stream;
    }

    public static void createLazy(Ruby runtime) {
        RubyModule m = runtime.getClassFromPath("Enumerator");
        RubyClass lazy = m.defineClassUnder("Lazy", runtime.getObject(), (Ruby ruby, RubyClass klass) ->
            new RubyLazyEnumerator(ruby, klass)
        );
        lazy.defineAnnotatedMethods(RubyLazyEnumerator.class);
    }

    @JRubyMethod(rest = true)
    public IRubyObject initialize(ThreadContext context, IRubyObject[] args, Block block) {
        Arity.checkArgumentCount(context.getRuntime(), args, 1, 2);
        this.object = args[0];
        this.stream = this.object.convertToArray().stream();
        if (args.length > 1) this.size = args[1];
        return this;
    }

    @JRubyMethod
    public IRubyObject map(ThreadContext context, Block block) {
        Ruby runtime = context.getRuntime();
        if (block.isGiven())
            context.getRuntime().newArgumentError("tried to call lazy map without a block");

        return new RubyLazyEnumerator(context, getModule(runtime), this.stream.map(s -> block.call(context, s)));
    }

    @JRubyMethod
    public IRubyObject force(ThreadContext context) {
        return RubyArray.newArray(context.getRuntime(), this.stream.collect(Collectors.toList()).toArray(new IRubyObject[] {}));
    }

    private RubyClass getModule(Ruby runtime) {
        return (RubyClass) runtime.getClassFromPath("Enumerator::Lazy");
    }
}