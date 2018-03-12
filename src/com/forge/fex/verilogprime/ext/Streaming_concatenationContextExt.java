package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Streaming_concatenationContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Streaming_concatenationContextExt extends AbstractBaseExt {

	public Streaming_concatenationContextExt(Streaming_concatenationContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Streaming_concatenationContext getContext() {
		return (Streaming_concatenationContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).streaming_concatenation());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Streaming_concatenationContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Streaming_concatenationContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}