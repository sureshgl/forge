package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Nonrange_variable_lvalueContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Nonrange_variable_lvalueContextExt extends AbstractBaseExt {

	public Nonrange_variable_lvalueContextExt(Nonrange_variable_lvalueContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Nonrange_variable_lvalueContext getContext() {
		return (Nonrange_variable_lvalueContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).nonrange_variable_lvalue());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Nonrange_variable_lvalueContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Nonrange_variable_lvalueContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}