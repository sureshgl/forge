package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Program_itemContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Program_itemContextExt extends AbstractBaseExt {

	public Program_itemContextExt(Program_itemContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Program_itemContext getContext() {
		return (Program_itemContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).program_item());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Program_itemContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + Program_itemContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}