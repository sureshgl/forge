package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.ImportstrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class ImportstrContextExt extends AbstractBaseExt {

	public ImportstrContextExt(ImportstrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public ImportstrContext getContext() {
		return (ImportstrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).importstr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof ImportstrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + ImportstrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}