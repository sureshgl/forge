package com.forge.parser.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.parser.PopulateExtendedContextVisitor;
import com.forge.parser.gen.ForgeParser.Memory_identifierContext;

public class Memory_identifierContextExt extends AbstractBaseExt {

	public Memory_identifierContextExt(Memory_identifierContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Memory_identifierContext getContext() {
		return (Memory_identifierContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).memory_identifier());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Memory_identifierContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Memory_identifierContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}
