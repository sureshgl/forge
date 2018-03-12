package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Covergroup_identifierContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Covergroup_identifierContextExt extends AbstractBaseExt {

	public Covergroup_identifierContextExt(Covergroup_identifierContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Covergroup_identifierContext getContext() {
		return (Covergroup_identifierContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).covergroup_identifier());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Covergroup_identifierContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Covergroup_identifierContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}