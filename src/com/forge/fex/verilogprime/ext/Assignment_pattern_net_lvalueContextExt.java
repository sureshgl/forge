package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Assignment_pattern_net_lvalueContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Assignment_pattern_net_lvalueContextExt extends AbstractBaseExt {

	public Assignment_pattern_net_lvalueContextExt(Assignment_pattern_net_lvalueContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Assignment_pattern_net_lvalueContext getContext() {
		return (Assignment_pattern_net_lvalueContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).assignment_pattern_net_lvalue());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Assignment_pattern_net_lvalueContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Assignment_pattern_net_lvalueContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}