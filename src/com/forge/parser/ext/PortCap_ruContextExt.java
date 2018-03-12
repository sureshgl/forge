package com.forge.parser.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.parser.PopulateExtendedContextVisitor;
import com.forge.parser.gen.ForgeParser.PortCap_ruContext;

public class PortCap_ruContextExt extends AbstractBaseExt {

	public PortCap_ruContextExt(PortCap_ruContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public PortCap_ruContext getContext() {
		return (PortCap_ruContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).portCap_ru());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof PortCap_ruContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + PortCap_ruContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}
