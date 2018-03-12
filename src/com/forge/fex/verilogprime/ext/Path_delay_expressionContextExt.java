package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Path_delay_expressionContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Path_delay_expressionContextExt extends AbstractBaseExt {

	public Path_delay_expressionContextExt(Path_delay_expressionContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Path_delay_expressionContext getContext() {
		return (Path_delay_expressionContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).path_delay_expression());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Path_delay_expressionContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Path_delay_expressionContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}