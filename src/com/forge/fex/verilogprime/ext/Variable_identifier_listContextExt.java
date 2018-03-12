package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Variable_identifier_listContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Variable_identifier_listContextExt extends AbstractBaseExt {

	public Variable_identifier_listContextExt(Variable_identifier_listContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Variable_identifier_listContext getContext() {
		return (Variable_identifier_listContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).variable_identifier_list());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Variable_identifier_listContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Variable_identifier_listContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}