package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Module_common_itemContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Module_common_itemContextExt extends AbstractBaseExt {

	public Module_common_itemContextExt(Module_common_itemContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Module_common_itemContext getContext() {
		return (Module_common_itemContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).module_common_item());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Module_common_itemContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Module_common_itemContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}