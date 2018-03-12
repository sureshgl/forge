package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.BytestrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class BytestrContextExt extends AbstractBaseExt {

	public BytestrContextExt(BytestrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public BytestrContext getContext() {
		return (BytestrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).bytestr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof BytestrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + BytestrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}