package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Module_keywordContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Module_keywordContextExt extends AbstractBaseExt {

	public Module_keywordContextExt(Module_keywordContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Module_keywordContext getContext() {
		return (Module_keywordContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).module_keyword());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Module_keywordContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Module_keywordContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}