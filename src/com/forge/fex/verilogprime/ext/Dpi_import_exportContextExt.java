package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Dpi_import_exportContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Dpi_import_exportContextExt extends AbstractBaseExt {

	public Dpi_import_exportContextExt(Dpi_import_exportContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Dpi_import_exportContext getContext() {
		return (Dpi_import_exportContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).dpi_import_export());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Dpi_import_exportContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Dpi_import_exportContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}