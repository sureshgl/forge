package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Strength0Context;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Strength0ContextExt extends AbstractBaseExt {

	public Strength0ContextExt(Strength0Context ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Strength0Context getContext() {
		return (Strength0Context) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).strength0());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Strength0Context) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + Strength0Context.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}