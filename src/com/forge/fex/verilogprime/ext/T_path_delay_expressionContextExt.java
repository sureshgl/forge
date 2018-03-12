package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.T_path_delay_expressionContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class T_path_delay_expressionContextExt extends AbstractBaseExt {

	public T_path_delay_expressionContextExt(T_path_delay_expressionContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public T_path_delay_expressionContext getContext() {
		return (T_path_delay_expressionContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).t_path_delay_expression());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof T_path_delay_expressionContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ T_path_delay_expressionContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}