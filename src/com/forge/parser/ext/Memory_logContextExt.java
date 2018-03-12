package com.forge.parser.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.parser.PopulateExtendedContextVisitor;
import com.forge.parser.gen.ForgeParser.Memory_logContext;

public class Memory_logContextExt extends AbstractBaseExt {

	public Memory_logContextExt(Memory_logContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Memory_logContext getContext() {
		return (Memory_logContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).memory_log());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Memory_logContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + Memory_logContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}
