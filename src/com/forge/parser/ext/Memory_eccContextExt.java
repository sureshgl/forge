package com.forge.parser.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.parser.PopulateExtendedContextVisitor;
import com.forge.parser.gen.ForgeParser.Memory_eccContext;

public class Memory_eccContextExt extends AbstractBaseExt {

	public Memory_eccContextExt(Memory_eccContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Memory_eccContext getContext() {
		return (Memory_eccContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).memory_ecc());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Memory_eccContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + Memory_eccContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}
