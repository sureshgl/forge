package com.forge.parser.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.parser.PopulateExtendedContextVisitor;
import com.forge.parser.gen.ForgeParser.Cpu_access_action_part1Context;

public class Cpu_access_action_part1ContextExt extends AbstractBaseExt {

	public Cpu_access_action_part1ContextExt(Cpu_access_action_part1Context ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Cpu_access_action_part1Context getContext() {
		return (Cpu_access_action_part1Context) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).cpu_access_action_part1());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Cpu_access_action_part1Context) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Cpu_access_action_part1Context.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}