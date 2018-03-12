package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Stream_expressionContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Stream_expressionContextExt extends AbstractBaseExt {

	public Stream_expressionContextExt(Stream_expressionContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Stream_expressionContext getContext() {
		return (Stream_expressionContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).stream_expression());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Stream_expressionContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Stream_expressionContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}