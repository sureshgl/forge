package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Interface_itemContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Interface_itemContextExt extends AbstractBaseExt {

	public Interface_itemContextExt(Interface_itemContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Interface_itemContext getContext() {
		return (Interface_itemContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).interface_item());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Interface_itemContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Interface_itemContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}