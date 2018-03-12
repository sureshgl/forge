package com.forge.parser.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.parser.PopulateExtendedContextVisitor;
import com.forge.parser.gen.ForgeParser.Register_identifierContext;

public class Register_identifierContextExt extends AbstractBaseExt {

	public Register_identifierContextExt(Register_identifierContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Register_identifierContext getContext() {
		return (Register_identifierContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).register_identifier());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Register_identifierContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Register_identifierContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}
