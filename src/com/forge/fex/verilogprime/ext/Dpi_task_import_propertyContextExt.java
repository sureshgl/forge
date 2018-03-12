package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Dpi_task_import_propertyContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Dpi_task_import_propertyContextExt extends AbstractBaseExt {

	public Dpi_task_import_propertyContextExt(Dpi_task_import_propertyContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Dpi_task_import_propertyContext getContext() {
		return (Dpi_task_import_propertyContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).dpi_task_import_property());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Dpi_task_import_propertyContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Dpi_task_import_propertyContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}