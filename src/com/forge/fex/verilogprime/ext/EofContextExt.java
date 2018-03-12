package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.EofContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class EofContextExt extends AbstractBaseExt {

	public EofContextExt(EofContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public EofContext getContext() {
		return (EofContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).eof());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof EofContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + EofContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}