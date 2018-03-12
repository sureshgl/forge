package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.PackedstrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class PackedstrContextExt extends AbstractBaseExt {

	public PackedstrContextExt(PackedstrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public PackedstrContext getContext() {
		return (PackedstrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).packedstr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof PackedstrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + PackedstrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}