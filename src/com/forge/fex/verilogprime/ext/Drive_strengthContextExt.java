package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Drive_strengthContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Drive_strengthContextExt extends AbstractBaseExt {

	public Drive_strengthContextExt(Drive_strengthContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Drive_strengthContext getContext() {
		return (Drive_strengthContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).drive_strength());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Drive_strengthContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Drive_strengthContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}