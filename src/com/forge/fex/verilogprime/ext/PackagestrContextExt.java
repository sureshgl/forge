package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.PackagestrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class PackagestrContextExt extends AbstractBaseExt {

	public PackagestrContextExt(PackagestrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public PackagestrContext getContext() {
		return (PackagestrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).packagestr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof PackagestrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + PackagestrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}