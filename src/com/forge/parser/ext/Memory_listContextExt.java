package com.forge.parser.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.parser.PopulateExtendedContextVisitor;
import com.forge.parser.gen.ForgeParser.Memory_listContext;

public class Memory_listContextExt extends AbstractBaseExt {

	public Memory_listContextExt(Memory_listContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Memory_listContext getContext() {
		return (Memory_listContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).memory_list());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Memory_listContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + Memory_listContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}
