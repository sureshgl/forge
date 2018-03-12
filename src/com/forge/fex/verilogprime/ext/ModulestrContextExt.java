package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.ModulestrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class ModulestrContextExt extends AbstractBaseExt {

	public ModulestrContextExt(ModulestrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public ModulestrContext getContext() {
		return (ModulestrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).modulestr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof ModulestrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + ModulestrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}