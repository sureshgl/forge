package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Udp_declaration_port_listContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Udp_declaration_port_listContextExt extends AbstractBaseExt {

	public Udp_declaration_port_listContextExt(Udp_declaration_port_listContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Udp_declaration_port_listContext getContext() {
		return (Udp_declaration_port_listContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).udp_declaration_port_list());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Udp_declaration_port_listContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Udp_declaration_port_listContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}