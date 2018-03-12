package com.forge.parser.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.parser.PopulateExtendedContextVisitor;
import com.forge.parser.gen.ForgeParser.PortCap_xmContext;

public class PortCap_xmContextExt extends AbstractBaseExt {

	public PortCap_xmContextExt(PortCap_xmContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public PortCap_xmContext getContext() {
		return (PortCap_xmContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).portCap_xm());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof PortCap_xmContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + PortCap_xmContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}
