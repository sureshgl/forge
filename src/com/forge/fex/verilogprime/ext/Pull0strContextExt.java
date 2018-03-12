package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Pull0strContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Pull0strContextExt extends AbstractBaseExt {

	public Pull0strContextExt(Pull0strContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Pull0strContext getContext() {
		return (Pull0strContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).pull0str());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Pull0strContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + Pull0strContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}