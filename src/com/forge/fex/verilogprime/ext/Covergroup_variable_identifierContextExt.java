package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Covergroup_variable_identifierContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Covergroup_variable_identifierContextExt extends AbstractBaseExt {

	public Covergroup_variable_identifierContextExt(Covergroup_variable_identifierContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Covergroup_variable_identifierContext getContext() {
		return (Covergroup_variable_identifierContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).covergroup_variable_identifier());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Covergroup_variable_identifierContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Covergroup_variable_identifierContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}