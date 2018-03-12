package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Generate_itemContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Generate_itemContextExt extends AbstractBaseExt {

	public Generate_itemContextExt(Generate_itemContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Generate_itemContext getContext() {
		return (Generate_itemContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).generate_item());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Generate_itemContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + Generate_itemContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}