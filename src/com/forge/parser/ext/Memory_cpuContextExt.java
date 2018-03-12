package com.forge.parser.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.parser.PopulateExtendedContextVisitor;
import com.forge.parser.gen.ForgeParser.Memory_cpuContext;

public class Memory_cpuContextExt extends AbstractBaseExt {

	public Memory_cpuContextExt(Memory_cpuContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Memory_cpuContext getContext() {
		return (Memory_cpuContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).memory_cpu());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Memory_cpuContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + Memory_cpuContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}
