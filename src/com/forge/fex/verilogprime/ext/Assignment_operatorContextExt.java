package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Assignment_operatorContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Assignment_operatorContextExt extends AbstractBaseExt {

	public Assignment_operatorContextExt(Assignment_operatorContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Assignment_operatorContext getContext() {
		return (Assignment_operatorContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).assignment_operator());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Assignment_operatorContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Assignment_operatorContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}