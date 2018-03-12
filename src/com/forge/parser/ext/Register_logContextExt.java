package com.forge.parser.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.parser.PopulateExtendedContextVisitor;
import com.forge.parser.gen.ForgeParser.Register_logContext;

public class Register_logContextExt extends AbstractBaseExt {

	public Register_logContextExt(Register_logContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Register_logContext getContext() {
		return (Register_logContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).register_log());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Register_logContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + Register_logContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}
