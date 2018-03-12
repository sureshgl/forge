package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Identifier_listContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Identifier_listContextExt extends AbstractBaseExt {

	public Identifier_listContextExt(Identifier_listContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Identifier_listContext getContext() {
		return (Identifier_listContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).identifier_list());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Identifier_listContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Identifier_listContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}