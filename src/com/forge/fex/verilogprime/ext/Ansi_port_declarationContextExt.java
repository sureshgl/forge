package com.forge.fex.verilogprime.ext;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Ansi_port_declarationContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Ansi_port_declarationContextExt extends AbstractBaseExt {

	public Ansi_port_declarationContextExt(Ansi_port_declarationContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Ansi_port_declarationContext getContext() {
		return (Ansi_port_declarationContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).ansi_port_declaration());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Ansi_port_declarationContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Ansi_port_declarationContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
	
	@Override
	public void populatePorts(Map<String, ParserRuleContext> portsMap) {
		List<String> ports = new ArrayList<>();
		getPorts(ports);
		for (String port : ports) {
			portsMap.put(port, getContext());
		}
	}
}