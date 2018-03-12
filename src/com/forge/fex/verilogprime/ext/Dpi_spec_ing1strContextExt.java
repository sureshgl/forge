package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Dpi_spec_ing1strContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Dpi_spec_ing1strContextExt extends AbstractBaseExt {

	public Dpi_spec_ing1strContextExt(Dpi_spec_ing1strContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Dpi_spec_ing1strContext getContext() {
		return (Dpi_spec_ing1strContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).dpi_spec_ing1str());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Dpi_spec_ing1strContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Dpi_spec_ing1strContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}