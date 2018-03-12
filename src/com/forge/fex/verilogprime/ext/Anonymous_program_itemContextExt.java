package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Anonymous_program_itemContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Anonymous_program_itemContextExt extends AbstractBaseExt {

	public Anonymous_program_itemContextExt(Anonymous_program_itemContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Anonymous_program_itemContext getContext() {
		return (Anonymous_program_itemContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).anonymous_program_item());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Anonymous_program_itemContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Anonymous_program_itemContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}