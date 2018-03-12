package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Import_exportContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Import_exportContextExt extends AbstractBaseExt {

	public Import_exportContextExt(Import_exportContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Import_exportContext getContext() {
		return (Import_exportContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).import_export());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Import_exportContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + Import_exportContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}