package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Stream_operatorContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Stream_operatorContextExt extends AbstractBaseExt {

	public Stream_operatorContextExt(Stream_operatorContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Stream_operatorContext getContext() {
		return (Stream_operatorContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).stream_operator());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Stream_operatorContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Stream_operatorContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}