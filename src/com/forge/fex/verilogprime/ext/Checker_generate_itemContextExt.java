package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Checker_generate_itemContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Checker_generate_itemContextExt extends AbstractBaseExt {

	public Checker_generate_itemContextExt(Checker_generate_itemContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Checker_generate_itemContext getContext() {
		return (Checker_generate_itemContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).checker_generate_item());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Checker_generate_itemContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Checker_generate_itemContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}