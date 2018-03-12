package com.forge.parser.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.parser.PopulateExtendedContextVisitor;
import com.forge.parser.gen.ForgeParser.Cpu_access_actionContext;

public class Cpu_access_actionContextExt extends AbstractBaseExt {

	public Cpu_access_actionContextExt(Cpu_access_actionContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Cpu_access_actionContext getContext() {
		return (Cpu_access_actionContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).cpu_access_action());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Cpu_access_actionContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Cpu_access_actionContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}
