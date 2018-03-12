package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Pull1strContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Pull1strContextExt extends AbstractBaseExt {

	public Pull1strContextExt(Pull1strContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Pull1strContext getContext() {
		return (Pull1strContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).pull1str());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Pull1strContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + Pull1strContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}