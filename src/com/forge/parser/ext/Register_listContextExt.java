package com.forge.parser.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.parser.PopulateExtendedContextVisitor;
import com.forge.parser.gen.ForgeParser.Register_listContext;

public class Register_listContextExt extends AbstractBaseExt {

	public Register_listContextExt(Register_listContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Register_listContext getContext() {
		return (Register_listContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).register_list());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Register_listContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + Register_listContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}
