package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Bins_selectionContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Bins_selectionContextExt extends AbstractBaseExt {

	public Bins_selectionContextExt(Bins_selectionContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Bins_selectionContext getContext() {
		return (Bins_selectionContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).bins_selection());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Bins_selectionContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Bins_selectionContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}