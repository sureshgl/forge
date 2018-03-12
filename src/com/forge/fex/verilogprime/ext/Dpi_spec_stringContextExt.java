package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Dpi_spec_stringContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Dpi_spec_stringContextExt extends AbstractBaseExt {

	public Dpi_spec_stringContextExt(Dpi_spec_stringContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Dpi_spec_stringContext getContext() {
		return (Dpi_spec_stringContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).dpi_spec_string());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Dpi_spec_stringContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Dpi_spec_stringContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}