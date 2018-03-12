package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Topmodule_identifierContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Topmodule_identifierContextExt extends AbstractBaseExt {

	public Topmodule_identifierContextExt(Topmodule_identifierContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Topmodule_identifierContext getContext() {
		return (Topmodule_identifierContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).topmodule_identifier());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Topmodule_identifierContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Topmodule_identifierContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}