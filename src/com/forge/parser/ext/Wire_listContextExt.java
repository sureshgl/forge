package com.forge.parser.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.parser.PopulateExtendedContextVisitor;
import com.forge.parser.gen.ForgeParser.Wire_listContext;

public class Wire_listContextExt extends AbstractBaseExt {

	public Wire_listContextExt(Wire_listContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Wire_listContext getContext() {
		return (Wire_listContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).wire_list());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Wire_listContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + Wire_listContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}
