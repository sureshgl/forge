package com.forge.parser.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.parser.PopulateExtendedContextVisitor;
import com.forge.parser.gen.ForgeParser.MasterContext;

public class MasterContextExt extends AbstractBaseExt {

	public MasterContextExt(MasterContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public MasterContext getContext() {
		return (MasterContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).master());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof MasterContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ MasterContextExt.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}
